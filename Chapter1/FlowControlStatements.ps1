# 1.2.4. Flow-Control Statements
$i=0; while ($i++ -lt 10) { if ($i % 2 - 1) {"$i is even"}}  # while
foreach ($i in 1..10) { if ($i % 2 - 1) {"$i is even"}}  # foreach
1..10 | foreach { if ($_ % 2 - 1) {"$_ is even"}}  # flow control using pipelines