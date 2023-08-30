work_folder=$PWD

hdfs dfs -rm -r /homework/job3
# creating the job folder
hdfs dfs -mkdir /homework/job3
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job3

rm -f max.txt
echo "Job 3 - Miglior mese per anno"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job3.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job3.r' -input /homework/job3/Ordini.csv -output /homework/job3/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /homework/job3/output/part-00000
hdfs dfs -copyToLocal /homework/job3/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job3: ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./max.txt
hdfs dfs -mv /homework/job3/output/part-00000 /homework/job3/output/max


