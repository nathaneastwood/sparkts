## Introduction

This document is here as a soundboard for ideas and learnings around the `sparklyr` package.

## Data Types

sparklyr has a function named [`sdf_schema()`](https://www.rdocumentation.org/packages/sparklyr/versions/0.7.0/topics/sdf_schema) for exploring the columns of a tibble on the R side. The return value is a list, and each element is a list with two elements, containing the name and data type of each column.

Here is a comparison of how R data types map to Spark data types. Other data types are not currently supported by `sparklyr`.

| R type | Spark type |
---------|-------------
| logical | BooleanType |
| numeric | DoubleType |
| integer | IntegerType |
| character | StringType |
| list | ArrayType |

`sparklyr` [doesn't currently have the ability](https://github.com/rstudio/sparklyr/issues/1324) to pass over more complex data types such as a `List[String]`. 

### Using other data types

When passing an R `list` over to Scala, we get a Scala `ArrayType` and there is no current way to send a Scala `List` from R using `sparklyr`. However, some of our Scala functions require `List` inputs. Potential solutions to this issue are:

1. Use `Seq` instead of `List` as the input type since `Array` has also the `Seq` trait in Scala, so everything works out-of-the-box.
2. Use overloading, which allows us to define methods of same name but having different parameters or data types, though this [has issues](https://stackoverflow.com/questions/2510108/why-avoid-method-overloading). For an example of how this works, see [this link](https://www.javatpoint.com/scala-method-overloading).
3. Define a new Scala method for the same class that is called from R, which effectively invokes the `toList` function on the `ArrayType` and then calls the existing Scala method.

We can create Java `ArrayList`s in the Spark environment using the following code:

```r
# map some R vector `x` to a java ArrayList
al <- invoke_new(sc, "java.util.ArrayList")
lapply(x, FUN = function(y){invoke(al, "add", y)})
```

Note we don't need to reassign the results of the `lapply` because it is adding values to the Scala `List` in the JVM. We can then convert this code to a Scala `List` using:

```r
invoke_static(sc, "scala.collection.JavaConversions", "asScalaBuffer", al) %>%
  invoke("toSeq") %>%
  invoke("toList")
```

## What is a `static` method?

A `static` method is one type of method which doesn't need any object to be initialized for it to be called. For instance, here’s an example of a method named `increment` in a Scala object named `StringUtils`:

```scala
object StringUtils {
  def increment(s: String) = s.map(c => (c + 1).toChar)
}
```

Because it’s defined inside an object (not a class), the `increment` method can be called directly on the `StringUtils` object, without requiring an instance of `StringUtils` to be created:

```scala
scala> StringUtils.increment("HAL") 
res0: String = IBM
```

In fact, when an object is defined like this without a corresponding class, you can’t create an instance of it. This line of code won’t compile:

```scala
val utils = new StringUtils
```

So let's say you want to create a class that has instance methods and static methods. First you define nonstatic (instance) members in your *class*, and define members that you want to appear as “static” members in an *object* that has the same name as the class, and is in the same file as the class. This object is known as a *companion* object. For example:

```scala
// Pizza class
class Pizza (var crustType: String) {
  override def toString = "Crust type is " + crustType
}

// companion object
object Pizza {
  val CRUST_TYPE_THIN = "thin" 
  val CRUST_TYPE_THICK = "thick" 
  def getFoo = "Foo"
}
```

With the `Pizza` class and `Pizza` object defined in the same file (presumably named *Pizza.scala*), members of the `Pizza` object can be accessed as so:

```scala
println(Pizza.CRUST_TYPE_THIN)
println(Pizza.getFoo)
```

You can also create a new `Pizza` instance and use it as usual:

```scala
var p = new Pizza(Pizza.CRUST_TYPE_THICK)
println(p)
```
