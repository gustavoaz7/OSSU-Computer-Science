# find . -name *.vm -print0 | xargs -0 -n1 dirname | sort --unique

for testFile in $(find * -name '*.tst' ! -name '*VME.tst'); do
    printf "➜ Testing: $testFile\n"
    testFileDir="${testFile%/*}"

    node vmTranslator.js "$testFileDir"

    sh ../nand2tetris/tools/CPUEmulator.sh "$testFile"

    printf "\n"
done
