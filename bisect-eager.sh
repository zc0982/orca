set +e
F=config/scripts/build/mobile-web-app/verify-mobile-web-app-bundle.mjs
for c in 0025e661ff7 84bd7ed4198 354da7714a1 bc8085021b0 8d2cce9ea91 ed3a669eff5 1ec2eb7579f 7859fc77378 7859fc77378~1; do
  git checkout -q -f $c
  pnpm install --frozen-lockfile >/dev/null 2>&1
  (cd mobile && pnpm install --frozen-lockfile >/dev/null 2>&1)
  sed -i "s/^export const MOBILE_WEB_APP_BUNDLE_MAX_EAGER_BYTES = .*/export const MOBILE_WEB_APP_BUNDLE_MAX_EAGER_BYTES = 1/" $F
  out=$(pnpm run build:mobile-web 2>&1)
  echo "== $c $(echo "$out" | grep -oE "is [0-9]+ bytes, over the Phase C eager" | head -1) $(echo "$out" | grep -iE "error" | head -2 | tr '\n' ' ' | cut -c1-200)"
  git checkout -q -- $F
done
