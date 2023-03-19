# utxoin="63f966e6657090eb9be8bbd57d5ce0399d6aaf9e94b732afcd31372c343fbe13#1"
utxoin="8c1c39417a209d2f7f00244f89bc5768ed5d89650c60365320e1545938c88020#1"
address="addr_test1qp65draw5za4msm4sqp9wtv4yejvehecceml20cc6waewrjfqx4dgsjqxh2gql7zjr2776l3thnxgtcvjg3cm8dad3lqn484e6"
output="2000000000"
change="addr_test1vqw66gv28k5m0rtsvf8q0mhqf53k4jnvkng8ynd2v5kqryqwt23dw"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$utxoin" \
    --change-address $change \
    --metadata-json-file metadata.json \
    --out-file tx.unsigned

cardano-cli transaction sign \
    --tx-body-file tx.unsigned \
    --signing-key-file "keys/alice.skey" \
    --testnet-magic 2 \
    --out-file tx.signed

cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file tx.signed

tid=$(cardano-cli transaction txid --tx-file tx.signed)
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"

        # --tx-in-script-file "$assets/gift.plutus" \
    # --tx-in-inline-datum-present \
    # --tx-in-redeemer-file "$assets/unit.json" \
    # --tx-in-collateral "$collateral" \
    # --protocol-params-file "$pp" \
