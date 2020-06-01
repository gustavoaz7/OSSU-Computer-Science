const fs = require("fs");
const path = require("path");
const { compile } = require("./compiler");

const TRAILING_SLASH_REGEX = /\/$/;

function getPathsFromInput() {
  const inputPath = process.argv[2].replace(TRAILING_SLASH_REGEX, "");
  if (fs.statSync(inputPath).isDirectory()) {
    return fs.readdirSync(inputPath).reduce(
      (acc, file) =>
        path.extname(file) === ".jack"
          ? {
              ...acc,
              jackPaths: [...acc.jackPaths, `${inputPath}/${file}`],
              vmPaths: [
                ...acc.vmPaths,
                `${inputPath}/${file.replace(/(.jack)$/, ".vm")}`,
              ],
            }
          : acc,
      { jackPaths: [], vmPaths: [] }
    );
  } else {
    const vmPaths = [inputPath.replace(/\.jack$/, ".vm")];
    const jackPaths = [inputPath];
    return { jackPaths, vmPaths };
  }
}

const { jackPaths, vmPaths } = getPathsFromInput();

jackPaths.forEach((jackPath, i) => {
  const vmPath = vmPaths[i];
  const jackCode = fs.readFileSync(jackPath, { encoding: "utf8" });

  console.log(`Compiling ${jackPath} into ${vmPath}\n`);

  const vmCode = compile(jackCode);

  fs.writeFileSync(vmPath, vmCode, { encoding: "utf8" });
});
