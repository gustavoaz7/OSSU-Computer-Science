for asmFile in $(find * -name '*.asm'); do
    printf "➜ Testing $asmFile\n"

    fileName="${asmFile%.*}"

    node hackAssembler.js "$asmFile"
done