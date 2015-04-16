package com.xebia.spark.randomForestClassification.solution


import com.xebia.spark.randomForestClassification.solution.features.Engineering
import com.xebia.spark.randomForestClassification.solution.tools.Utilities._
import com.xebia.spark.randomForestClassification.solution.modelling.TreeModelling.{randomForestTrainClassifier, gridSearchRandomForestClassifier}
import org.apache.spark.{SparkContext, SparkConf}


object RandomForestClassificationGrid {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("RandomForest").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Loading data
    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")

    // Parsing Data
    val data = extractHeader(rawData)._2

    // Feature Engineering
    val cleanData = Engineering.featureEngineering(data)

    // Splitting data
    val Array(trainSet, valSet, testSet) = cleanData.randomSplit(Array(0.7, 0.15, 0.15))

    // Modelling
    // -------- Tuning parameters
    val categoricalFeaturesInfo = Map(1 -> 2, 6 -> 4)
    val bestParams = gridSearchRandomForestClassifier(trainSet, valSet,
      categoricalFeaturesInfo = categoricalFeaturesInfo, numTreesGrid = Array(10, 20),
      impurityGrid = Array("entropy", "gini"), maxDepthGrid = Array(5, 10), maxBinsGrid = Array(30, 50))

    // -------- Training the model
    val dataTrain = sc.union(trainSet, valSet)
    val model = (randomForestTrainClassifier _).tupled(bestParams)(dataTrain)

    // Prediction & Evaluation
    val (accuracyTrain, confusionTrain) = getMetricsRandomForest(model, dataTrain)
    val (accuracyTest, confusionTest) = getMetricsRandomForest(model, testSet)

    // Print results
    println(s"Best parameters found : \n $bestParams \n")

    println(s"Results for the training set")
    println(s"\t Accuracy: $accuracyTrain %")
    println(s"\t Confusion Matrix: \n $confusionTrain \n")

    println(s"Results for the test set")
    println(s"\t Accuracy: $accuracyTest %")
    println(s"\t Confusion Matrix: \n $confusionTest")

  }




}
