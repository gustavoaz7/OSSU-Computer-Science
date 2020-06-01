const registers = Array(16)
  .fill(null)
  .reduce((acc, cur, i) => ({
    ...acc,
    [`R${i}`]: i,
  }), {});

const generateSymbolTable = () =>
  new Map(
    Object.entries({
      SP: 0,
      LCL: 1,
      ARG: 2,
      THIS: 3,
      THAT: 4,
      ...registers,
      SCREEN: 16384,
      KBD: 24576,
    })
  );

module.exports = { generateSymbolTable };
