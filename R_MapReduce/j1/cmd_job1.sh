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
