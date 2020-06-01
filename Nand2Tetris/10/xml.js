const escapes = new Map(
  Object.entries({
    '<': '&lt;',
    '>': '&gt;',
    '&': '&amp;'
  })
);

const tokensToXml = tokens =>
`<tokens>
${tokens.map(tokenToXml).join('\n')}
</tokens>
`;

const tokenToXml = token => `<${token.type}> ${escapeValue(token.value)} </${token.type}>`;

const escapeValue = value => escapes.has(value) ? escapes.get(value) : value;

const treeToXml = tree => nodeToXml(tree, 0) + '\n';

const nodeToXml = (node, depth) =>
  node.hasOwnProperty('value') ? leafNodeToXml(node, depth) : nonLeafNodeToXml(node, depth);

const leafNodeToXml = (node, depth) => indent(depth) + tokenToXml(node);

const indent = depth => '  '.repeat(depth);

const nonLeafNodeToXml = (node, depth) => {
  const indentation = indent(depth);
  let xml = `${indentation}<${node.type}>`;
  if (node.children.length) {
      xml += '\n' + node.children.map(child => nodeToXml(child, depth + 1)).join('\n');
  }
  xml += `\n${indentation}</${node.type}>`;
  return xml;
};

module.exports = { tokensToXml, treeToXml };
