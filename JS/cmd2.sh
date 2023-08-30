work_folder=$PWD

# deleting the folder to ensure it doesn't exist
hdfs dfs -rm -r /homework/job2
# creating the job folder
hdfs dfs -mkdir /homework/job2
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job2

rm -f varianze
echo "Job2 - Varianze iniziato"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job2.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job2.r' -input /homework/job2/Ordini.csv -output /homework/job2/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /homework/job2/output/part-00000
hdfs dfs -copyToLocal /homework/job2/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job2 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./varianze
hdfs dfs -mv /homework/job2/output/part-00000 /homework/job2/output/varianze

