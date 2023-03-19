# utxoin="63f966e6657090eb9be8bbd57d5ce0399d6aaf9e94b732afcd31372c343fbe13#1"
utxoin="8e48730bb4ecac51c355ff665747a341b109c8db6f4555094193a9a66a9f0439#0"
address="addr_test1qz8a9te33ln0675t9atgvxmamgcjgyfgzcttjq5482lhzgwkx0qw82lv9jasu7cl0nggv5ps58rgg6mvt0t89fdsr82srsfq3f"
output="5000000"
change="addr_test1vqw66gv28k5m0rtsvf8q0mhqf53k4jnvkng8ynd2v5kqryqwt23dw"
policyid="5fc10bd9f783c0a2ddee2c7fec2eb0a3ff1b65831fe88d2a0c32837a"
tokenname=$(echo -n "OurWonderfullToken" | xxd -ps | tr -d '\n')

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in $utxoin \
    --tx-in "85144a236ec27b07ab9a7b155721d2454897f70e8733c3fbb1787c812288dcdc#0" \
    --tx-out $address+$output+"1000 24331b4c417e3a8351a0e6c72a3e61857b1138800cefcd51566015b8.4f7572576f6e64657266756c6c546f6b656e" \
    --change-address $change \
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
