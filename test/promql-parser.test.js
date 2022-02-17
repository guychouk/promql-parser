const assert = require('assert');

const parser = require('../lib/promql');

const metric = 'some_metric';

// should parse query: some_metric

assert.deepEqual(parser.parse(`${metric}`), { metric });

// should parse query: some_metric{label="value"}

assert.deepEqual(parser.parse(`${metric}{label="value"}`), {
  metric,
  selectors: [{ name: 'label', op: '=', value: 'value' }],
});

// should parse query: sum(some_metric{label="value"})

assert.deepEqual(parser.parse(`sum(${metric}{label="value"})`), {
  aggregator: 'sum',
  body: [{
    metric,
    selectors: [{ name: 'label', op: '=', value: 'value' }],
  }]
});

// should parse query: sum(some_metric{label="value"}) by (label)

assert.deepEqual(parser.parse(`sum(${metric}{label="value"}) by (label)`), {
  aggregator: 'sum',
  body: [{
    metric,
    selectors: [{ name: 'label', op: '=', value: 'value' }],
  }],
  aggregate_modifier: 'by',
  labels: ['label'],
});

// should parse query: rate(some_metric{label="value"}[5m]) by (label)

assert.deepEqual(parser.parse(`sum(rate(${metric}{label="value"}[5m])) by (label)`), {
  aggregator: 'sum',
  body: {
    func: 'rate',
    body: [
      {
        metric,
        range: '5m',
        selectors: [{ name: 'label', op: '=', value: 'value' }]
      }
    ]
  },
  aggregate_modifier: 'by',
  labels: ['label'],
});
