#
//  build-number.sh
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

set -euo pipefail

ENV_NAME="${FIREBASE_APP_ENV:-Debug}"
SRC="${PROJECT_DIR}/Config/Firebase/${ENV_NAME}/GoogleService-Info.plist"
DST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

if [ ! -f "$SRC" ]; then
  echo "Missing GoogleService-Info.plist for ${ENV_NAME} at $SRC"
  exit 1
fi

cp -f "$SRC" "$DST"
echo "Copied Firebase plist for ${ENV_NAME}"
