package com.xebia.spark.randomForestClassification.stubs


import com.xebia.spark.randomForestClassification.stubs.features.Engineering
import com.xebia.spark.randomForestClassification.stubs.tools.Utilities._
import com.xebia.spark.randomForestClassification.stubs.modelling.TreeModelling.randomForestTrainClassifier
import org.apache.spark.{SparkContext, SparkConf}


object RandomForestClassification {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("RandomForest").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Loading data
    // TODO : read file ./src/main/resources/data_titanic.csv

    // Parsing Data
    // TODO : use function in tools/Utilities to get an RDD without header

    // Feature Engineering
    // TODO : use the featureEngineering method in features/Engineering to get the cleaned data
    // Be carefull, you will get a RDD[LabeledPoint]

    // Splitting data
    // TODO : split the cleaned data in a train and test set (proportions 0.75, 0.25) using the 'randomSplit' method

    // Modelling
    // -------- Tuning parameters
    val categoricalFeaturesInfo = Map(1 -> 2, 6 -> 4)

    // -------- Training the model
    // TODO : use the randomForestTrainClassifier method to train a Random Forest (Use the parameters of your choice)

    // Prediction & Evaluation
    // TODO : get the accuracy and confusion matrix for the prediction on the test set using the getMetricsRandomForest method
    // TODO : do the same for the train set for comparison

    // Print results
    println(s"Results for the training set")
    // TODO : print the results obtained for the train set

    println(s"Results for the test set")
    // TODO : print the results obtained for the test set


  }

}
