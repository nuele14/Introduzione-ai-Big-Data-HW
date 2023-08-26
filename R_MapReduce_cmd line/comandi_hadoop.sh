#Script 1
work_folder=/home/hdoop/R/src/prj
# deleting the folder to ensure it doesn't exist
hdfs dfs -rm -r /prj/j1
# creating the job folder
hdfs dfs -mkdir /prj/j1
# copying the data to the hdfs
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j1

# changing the permissions of the R scripts
 cd $work_folder
 chmod 777 $work_folder/j1/mapper.r $work_folder/j1/reducer.r 12.
 # running the job via hadoop streaming
 hadoop jar /home/hdoop/Documents/hadoop-streaming-3.2.1.jar \ 15.-file/home/hdoop/R/src/prj/j1/mapper.r -mapper'Rscript
 /home/hdoop/R/src/prj/j1/mapper.r' \
 -file /home/hdoop/R/src/prj/j1/reducer.r -reducer 'Rscript
 /home/hdoop/R/src/prj/j1/reducer.r' \
 -input /prj/j1/Ordini.csv -output /prj/j1/output

 # showing the output
 hdfs dfs -cat /prj/j1/output/part-00000

# Per il codice di j2/cmd.sh fare riferimento a j1/cmd.sh sostituendo tutte le occorrenze di “j1” con “j2”.







