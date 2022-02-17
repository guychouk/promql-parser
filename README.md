# PromQL Parser

This project features a [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/) parser, written in JavaScript using [PEG.js](https://pegjs.org/).

The `lib/promql.js` is a parser which is generated from the `lib/promql.pegjs` [grammar](https://pegjs.org/documentation#grammar-syntax-and-semantics).

This parser can then be used to parse PromQL in the following manner:

> This parser is still very much work in progress, and some queries might not be supported - consider opening an issue if you spot one.

```javascript
const parser = require('promql-parser');

try {
  const query = parser.parse('sum(some_metric{with="filter"})');
  console.log(query);
} catch (err) {
  console.error(err);
}
```

The code above parses the PromQL query to an AST, which is then logged to the console.

For the structure of the AST, either run the code above and inspect the output, or check out the types in `index.d.ts`.

## Roadmap

This project aims to be as close as possible to the grammar defined in the [prometheus/prometheus](https://github.com/prometheus/prometheus/blob/main/web/ui/module/codemirror-promql/src/grammar/promql.grammar) repo.

It currently supports basic queries, here's what's currently missing:

- [ ] UnaryExpr
- [ ] OffsetExpr
- [ ] SubqueryExpr
- [ ] StepInvariantExpr

If you're in the mood, you could check out the grammar in the `lib/promql.pegjs` and submit a PR ;)

You can use the [PEG.js](https://pegjs.org/online) online editor to play with the grammar and test out different queries.
