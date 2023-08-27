work_folder=$PWD

hdfs dfs -rm -r /homework/job4
# creating the job folder
hdfs dfs -mkdir /homework/job4
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job4

rm -f min.txt
echo "Job 4 - Peggior mese per anno"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job4.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job4.r' -input /homework/job4/Ordini.csv -output /homework/job4/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /homework/job4/output/part-00000
hdfs dfs -copyToLocal /homework/job4/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job4 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./min.txt
hdfs dfs -mv /homework/job4/output/part-00000 /homework/job4/output/min
