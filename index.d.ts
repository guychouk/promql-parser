import type { Parser } from "pegjs";

export type Duration = {
  duration: number;
  unit:
    | "years"
    | "weeks"
    | "days"
    | "hours"
    | "minutes"
    | "seconds"
    | "milliseconds";
};

export type Expr =
  | BinaryExpr
  | number
  | string
  | AggregateExpr
  | FunctionCall
  | MatrixSelector
  | VectorSelector;

export type FunctionCall = { func: FunctionIndentifier; body: Array<Expr>; }

export type BinaryExpr = { left: Expr; op: BinaryOp; right: Expr };

export type AggregateExpr = {
  aggregator: AggregationOp;
  body: Array<Expr>;
  labels?: Array<string>;
  aggregate_modifier?: "by" | "without";
};

export type VectorSelector = {
  metric: string;
  selectors?: Array<LabelMatcher>;
};

export type LabelMatcher = { label: string; op: MatchOp; value: string };

export type MatrixSelector = VectorSelector & { range: Array<Duration> };

export type BinaryOp =
  | "-"
  | "+"
  | "*"
  | "%"
  | "/"
  | "=="
  | "!="
  | "<="
  | "<"
  | ">="
  | ">"
  | "=~"
  | "="
  | "!~"
  | "^";

export type MatchOp = "==" | "!=" | ">" | "<" | ">=" | "<=" | "=~" | "!~" | "=";

export type AggregationOp =
  | "sum"
  | "min"
  | "max"
  | "avg"
  | "group"
  | "stddev"
  | "stdvar"
  | "count"
  | "count_values"
  | "bottomk"
  | "topk"
  | "quantile";

export type FunctionIndentifier =
  | "abs"
  | "absent"
  | "absent_over_time"
  | "ceil"
  | "changes"
  | "clamp"
  | "clamp_max"
  | "clamp_min"
  | "day_of_month"
  | "day_of_week"
  | "days_in_month"
  | "delta"
  | "deriv"
  | "exp"
  | "floor"
  | "histogram_quantile"
  | "holt_winters"
  | "hour"
  | "idelta"
  | "increase"
  | "irate"
  | "label_join"
  | "label_replace"
  | "ln"
  | "log2"
  | "log10"
  | "max"
  | "minute"
  | "month"
  | "predict_linear"
  | "rate"
  | "resets"
  | "round"
  | "scalar"
  | "sgn"
  | "sort"
  | "sort_desc"
  | "sqrt"
  | "time"
  | "timestamp"
  | "vector"
  | "year";

export default Parser;
