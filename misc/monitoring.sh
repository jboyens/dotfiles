QUERY="SELECT query FROM pg_stat_activity WHERE state IN ('idle in transaction', 'active') AND (now() - xact_start) > '1 minute'::interval;"

while [[ ($(psql -h stress-db.myshyft.com -U daniel --command="${QUERY}" expresso_production)) ]]
do
      echo "yup";
      sleep 1;
done
