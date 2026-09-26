// Support scoped Conventional Commits and the breaking-change ! marker.
const parserOpts = {
  headerPattern: /^(\w+)(?:\(([^()\s]+)\))?!?: (.+)$/,
  headerCorrespondence: ["type", "scope", "subject"],
  breakingHeaderPattern: /^(\w+)(?:\(([^()\s]+)\))?!: (.+)$/,
  noteKeywords: ["BREAKING CHANGE", "BREAKING-CHANGE"],
};

module.exports = {
  branches: ["main"],
  tagFormat: "v${version}",
  plugins: [
    ["@semantic-release/commit-analyzer", { parserOpts }],
    ["@semantic-release/release-notes-generator", { parserOpts }],
    "@semantic-release/github",
  ],
};
