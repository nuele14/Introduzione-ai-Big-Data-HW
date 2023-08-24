work_folder=/home/hdoop/R/src/prj
hdfs dfs -rm -r /prj/j4
hdfs dfs -mkdir /prj/j4
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j4

cd $work_folder
chmod 777 $work_folder/j4/mapper.r $work_folder/j4/reducer.r 

hadoop jar /home/hdoop/Documents/hadoop-streaming-3.2.1.jar \
-file /home/hdoop/R/src/prj/j4/mapper.r  -mapper 'Rscript /home/hdoop/R/src/prj/j4/mapper.r' \
-file /home/hdoop/R/src/prj/j4/reducer.r -reducer 'Rscript /home/hdoop/R/src/prj/j4/reducer.r' \
-input /prj/j4/Ordini.csv -output /prj/j4/output 

hdfs dfs -cat /prj/j4/output/part-00000
