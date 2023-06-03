{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeApplications  #-}
{-# LANGUAGE TypeFamilies      #-}

module Homework1 where

import           Plutus.V1.Ledger.Interval
import           Plutus.V2.Ledger.Api (BuiltinData, POSIXTime, PubKeyHash,
                                       ScriptContext, Validator,
                                       ScriptContext (scriptContextTxInfo),
                                       TxInfo (txInfoValidRange),
                                       mkValidatorScript)
import           PlutusTx             (compile, unstableMakeIsData)
import           Plutus.V2.Ledger.Contexts (txSignedBy)
import           PlutusTx.Prelude     (Bool (..), (&&), not, (||), ($))
import           Utilities            (wrapValidator)

---------------------------------------------------------------------------------------------------
----------------------------------- ON-CHAIN / VALIDATOR ------------------------------------------

data VestingDatum = VestingDatum
    { beneficiary1 :: PubKeyHash
    , beneficiary2 :: PubKeyHash
    , deadline     :: POSIXTime
    }

unstableMakeIsData ''VestingDatum

{-# INLINABLE mkVestingValidator #-}
-- This should validate if either beneficiary1 has signed the transaction and the current slot is before or at the deadline
-- or if beneficiary2 has signed the transaction and the deadline has passed.
mkVestingValidator :: VestingDatum -> () -> ScriptContext -> Bool
mkVestingValidator dat () ctx =
        (signedByBeneficiary (beneficiary1 dat) && deadlineNotPassed) ||
        (signedByBeneficiary (beneficiary2 dat) && deadlinePassed)
    where
        info :: TxInfo
        info = scriptContextTxInfo ctx

        signedByBeneficiary :: PubKeyHash -> Bool
        signedByBeneficiary benificiary  = txSignedBy info benificiary

        deadlineNotPassed :: Bool
        deadlineNotPassed = contains (to $ deadline dat) $ txInfoValidRange info
        
        deadlinePassed :: Bool
        deadlinePassed = contains (Interval { ivFrom = LowerBound (Finite $ deadline dat) False, ivTo = UpperBound PosInf True }) $ txInfoValidRange info

{-# INLINABLE  mkWrappedVestingValidator #-}
mkWrappedVestingValidator :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mkWrappedVestingValidator = wrapValidator mkVestingValidator

validator :: Validator
validator = mkValidatorScript $$(compile [|| mkWrappedVestingValidator ||])
