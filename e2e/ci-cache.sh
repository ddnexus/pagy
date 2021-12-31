# run this in order to ensure the ci cache will get updated with the latest versions

rm -rf ci-cache.lock
for pkg in cypress @cypress/snapshot html-validate cypress-html-validate cypress-dark; do
  echo $pkg:"$(npm view $pkg version)" >> ci-cache.lock
done
echo 'The "ci-cache.lock" file has been generated with the following content:'
echo
cat ci-cache.lock
