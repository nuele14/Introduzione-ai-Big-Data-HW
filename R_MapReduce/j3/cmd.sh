work_folder=/home/hdoop/R/src/prj
hdfs dfs -rm -r /prj/j3
hdfs dfs -mkdir /prj/j3
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j3

cd $work_folder
chmod 777 $work_folder/j3/mapper.r $work_folder/j3/reducer.r 

hadoop jar /home/hdoop/Documents/hadoop-streaming-3.2.1.jar \
-file /home/hdoop/R/src/prj/j3/mapper.r  -mapper 'Rscript /home/hdoop/R/src/prj/j3/mapper.r' \
-file /home/hdoop/R/src/prj/j3/reducer.r -reducer 'Rscript /home/hdoop/R/src/prj/j3/reducer.r' \
-input /prj/j3/Ordini.csv -output /prj/j3/output 

hdfs dfs -cat /prj/j3/output/part-00000
