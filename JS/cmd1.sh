#work_folder=/home/hdoop/R/src/prj
work_folder=$PWD

hdfs dfs -rm -r /homework/job1
# creating the job folder
hdfs dfs -mkdir /homework/job1
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job1


rm -f medie_calcolate

echo "Job1 - Somme iniziato"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job1.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job1.r' -input /homework/job1/Ordini.csv -output /homework/job1/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /homework/job1/output/part-00000
hdfs dfs -copyToLocal /homework/job1/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job1 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./medie_calcolate
hdfs dfs -mv /homework/job1/output/part-00000 /homework/job1/output/medie_calcolate
