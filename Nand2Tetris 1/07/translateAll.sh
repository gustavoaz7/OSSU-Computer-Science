for vmFile in $(find * -name '*.vm'); do
    printf "➜ Testing $vmFile\n"

    fileName="${vmFile%.*}"
    testFile="$fileName".tst

    node vmTranslator.js "$vmFile"

    sh ../nand2tetris/tools/CPUEmulator.sh "$testFile"

    printf "\n"
done