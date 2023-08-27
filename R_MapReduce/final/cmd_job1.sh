#work_folder=/home/hdoop/R/src/prj
work_folder=$PWD
# deleting the folder to ensure it doesn't exist
hdfs dfs -rm -r /prj/j1
# creating the job folder
hdfs dfs -mkdir /prj/j1
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j1

# changing the permissions of the R scripts
cd $work_folder
#chmod 777 $work_folder/j1/mapper.r $work_folder/j1/reducer.r 
rm -f performance.txt
rm -f medie_calcolate

echo "Job1 - Somme iniziato"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job1.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job1.r' -input /prj/j1/Ordini.csv -output /prj/j1/output
end_time=$(date +%s) 
# showing the output
hdfs dfs -cat /prj/j1/output/part-00000
hdfs dfs -copyToLocal /prj/j1/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job1 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./medie_calcolate
hdfs dfs -mv /prj/j1/output/part-00000 /prj/j1/output/medie_calcolate
# deleting the folder to ensure it doesn't exist
hdfs dfs -rm -r /prj/j2
# creating the job folder
hdfs dfs -mkdir /prj/j2
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j2

rm -f varianze
echo "Job2 - Varianze iniziato"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job2.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job2.r' -input /prj/j2/Ordini.csv -output /prj/j2/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /prj/j2/output/part-00000
hdfs dfs -copyToLocal /prj/j2/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job2 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./varianze
hdfs dfs -mv /prj/j2/output/part-00000 /prj/j2/output/varianze

hdfs dfs -rm -r /prj/j3
# creating the job folder
hdfs dfs -mkdir /prj/j3
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j3

rm -f max.txt
echo "Job 3 - Miglior mese per anno"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job3.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job3.r' -input /prj/j3/Ordini.csv -output /prj/j3/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /prj/j3/output/part-00000
hdfs dfs -copyToLocal /prj/j3/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job3: ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./max.txt
hdfs dfs -mv /prj/j3/output/part-00000 /prj/j3/output/max

hdfs dfs -rm -r /prj/j4
# creating the job folder
hdfs dfs -mkdir /prj/j4
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j4

rm -f min.txt
echo "Job 4 - Peggior mese per anno"
start_time=$(date +%s)
# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job4.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job4.r' -input /prj/j4/Ordini.csv -output /prj/j4/output
end_time=$(date +%s)
# showing the output
hdfs dfs -cat /prj/j4/output/part-00000
hdfs dfs -copyToLocal /prj/j4/output/part-00000 ./

elapsed_time=$((end_time - start_time))
echo "Job4 : ${elapsed_time} seconds" >> performance.txt

mv ./part-00000 ./min.txt
hdfs dfs -mv /prj/j4/output/part-00000 /prj/j4/output/min
