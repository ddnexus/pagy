# run this in order to ensure the ci cache will get updated with the latest verions

rm -rf ci-cache.lock
for pkg in cypress @cypress/snapshot cypress-html-validate ; do
  echo $pkg:$(npm view $pkg version) >> ci-cache.lock
done
