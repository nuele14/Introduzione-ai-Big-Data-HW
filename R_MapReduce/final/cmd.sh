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

# running the job via haddop streaming
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper.r,$work_folder/reducer.r -mapper 'Rscript mapper.r' -reducer 'Rscript reducer.r' -input /prj/j1/Ordini.csv -output /prj/j1/output

# showing the output
hdfs dfs -cat /prj/j1/output/part-00000
hdfs dfs -copyToLocal /prj/j1/output/part-00000 ./

