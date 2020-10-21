#!/bin/sh

# KMS Key-RingとKeyは削除できない仕様のため、Importする
# Keyに関してはdestroyすると無効化されるので、復元する必要はあり
cd ../terraform/cloudfunctions
terraform import google_kms_key_ring.service_keyring projects/mintak/locations/us-central1/keyRings/cloudfunction-keyring
terraform import google_kms_crypto_key.service_key projects/mintak/locations/us-central1/keyRings/cloudfunction-keyring/cryptoKeys/mintaklinebot-key
