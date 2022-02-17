start = _ e:Expr { return e }

Expr
  = BinaryExpr
  / ParenExpr
  / NumberLiteral
  / StringLiteral
  / AggregateExpr
  / FunctionCall
  / MatrixSelector
  / VectorSelector

AggregateExpr
  = aggregator:AggregateOp modifier:AggregateModifier body:FunctionCallBody      { return { aggregator, body, ...modifier } }
  / aggregator:AggregateOp body:FunctionCallBody      modifier:AggregateModifier { return { aggregator, body, ...modifier } }
  / aggregator:AggregateOp body:FunctionCallBody                                 { return { aggregator, body } }

AggregateModifier 
  = _ aggregate_modifier:"by"      _ labels:GroupingLabels { return { aggregate_modifier, labels } }
  / _ aggregate_modifier:"without" _ labels:GroupingLabels { return { aggregate_modifier, labels } }
  
BinaryExpr
  = left:(
      ParenExpr
      / NumberLiteral
      / AggregateExpr
      / FunctionCall
      / MatrixSelector
      / VectorSelector
    ) _ op:BinaryOp _ right:Expr { return { left, op, right } }

ParenExpr 
  = "(" expr:Expr ")" { return expr }

FunctionCall 
  = func:FunctionIdentifier _ body:FunctionCallBody { return { func, body } }

FunctionCallBody 
  = _ "(" args:FunctionCallArgs ")" { return args }
  / "(" ")" {}

FunctionCallArgs
  = FunctionCall
  / args:(Expr ","?)* { return args.map(arg => arg[0]) }

MatrixSelector
  = selector:VectorSelector '[' range:Duration* ']' { return { ...selector, range } }

VectorSelector
  = metric:MetricIdentifier selectors:LabelMatchers { return { metric, selectors } }
  / metric:MetricIdentifier                         { return { metric } }
  / selectors:LabelMatchers                         { return { selectors } }

LabelMatchers 
  = "{" labels:(LabelMatcher ","? _)* "}" { return labels.map(l => l[0]) }
  / "{" _ "}" { return [] }

LabelMatcher 
  = _ label:LabelName _ op:MatchOp _ value:StringLiteral { return { label, op, value } }

GroupingLabels
  = '(' labels:(GroupingLabel ','? _)* ')' { return labels.map(l => l[0]) }

GroupingLabel 
  = LabelName

LabelName
  = chars:[a-zA-Z_]+ { return chars.join('') }
  
MetricIdentifier
  = Identifier

Identifier
  = chars:[a-zA-Z0-9_:]+ { return chars.join('') }

StringLiteral
  = '"' chars:[a-zA-Z0-9-_.*(){}$/]+ '"' { return chars.join('') }
  / "'" chars:[a-zA-Z0-9-_.*(){}$/]+ "'" { return chars.join('') }

NumberLiteral
  = digits:[0-9]+ { return parseInt(digits.join(""), 10) }

_ "whitespace"
  = [ \t\n\r]*
  
Duration
  = digits:[0-9]+ "y"  { return { duration: parseInt(digits.join(""), 10), unit: 'years' } }
  / digits:[0-9]+ "w"  { return { duration: parseInt(digits.join(""), 10), unit: 'weeks' } }
  / digits:[0-9]+ "d"  { return { duration: parseInt(digits.join(""), 10), unit: 'days' } }
  / digits:[0-9]+ "h"  { return { duration: parseInt(digits.join(""), 10), unit: 'hours' } }
  / digits:[0-9]+ "m"  { return { duration: parseInt(digits.join(""), 10), unit: 'minutes' } }
  / digits:[0-9]+ "s"  { return { duration: parseInt(digits.join(""), 10), unit: 'seconds' } }
  / digits:[0-9]+ "ms" { return { duration: parseInt(digits.join(""), 10), unit: 'milliseconds' } }

BinaryOp
  = "-"
  / "+"
  / "*"
  / "%"
  / "/"
  / "=="
  / "!="
  / "<="
  / "<"
  / ">="
  / ">"
  / "=~"
  / "="
  / "!~"
  / "^"

MatchOp 
  = '=='
  / '!='
  / '>'
  / '<'
  / '>='
  / '<='
  / '=~'
  / '!~'
  / '='

AggregateOp
  = 'sum'
  / 'min'
  / 'max'
  / 'avg'
  / 'group'
  / 'stddev'
  / 'stdvar'
  / 'count'
  / 'count_values'
  / 'bottomk'
  / 'topk'
  / 'quantile'

FunctionIdentifier
  = 'abs'
  / 'absent'
  / 'absent_over_time'
  / 'ceil'
  / 'changes'
  / 'clamp'
  / 'clamp_max'
  / 'clamp_min'
  / 'day_of_month'
  / 'day_of_week'
  / 'days_in_month'
  / 'delta'
  / 'deriv'
  / 'exp'
  / 'floor'
  / 'histogram_quantile'
  / 'holt_winters'
  / 'hour'
  / 'idelta'
  / 'increase'
  / 'irate'
  / 'label_join'
  / 'label_replace'
  / 'ln'
  / 'log2'
  / 'log10'
  / 'max'
  / 'minute'
  / 'month'
  / 'predict_linear'
  / 'rate'
  / 'resets'
  / 'round'
  / 'scalar'
  / 'sgn'
  / 'sort'
  / 'sort_desc'
  / 'sqrt'
  / 'time'
  / 'timestamp'
  / 'vector'
  / 'year'
