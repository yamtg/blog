---
title: 线程安全的单例
date: 2017-12-09 22:53:41
tags:  
    - JAVA
    - 设计模式
    - 线程安全
    - 高并发
categories: JAVA
comments: true
---

## Double Check Locking 双检查锁机制

为了达到线程安全，又能提高代码执行效率，我们这里可以采用DCL的双检查锁机制来完成，代码实现如下：

``` java
public class MySingleton {
	//使用volatile关键字保其可见性
	volatile private static MySingleton instance = null;
	private MySingleton(){}
	public static MySingleton getInstance() {
		try {  
			if(instance != null){//懒汉式 
			}else{
				//创建实例之前可能会有一些准备性的耗时工作 
				Thread.sleep(300);
				synchronized (MySingleton.class) {
					if(instance == null){//二次检查
						instance = new MySingleton();
					}
				}
			} 
		} catch (InterruptedException e) { 
			e.printStackTrace();
		}
		return instance;
	}
}
```

<!-- more -->

## 使用静态内置类实现单例模式

DCL解决了多线程并发下的线程安全问题，其实使用其他方式也可以达到同样的效果，代码实现如下：

{% codeblock lang:java %}
public class MySingleton {  
      
    //内部类  
    private static class MySingletonHandler{  
        private static MySingleton instance = new MySingleton();  
    }   
      
    private MySingleton(){}  
       
    public static MySingleton getInstance() {   
        return MySingletonHandler.instance;  
    }  
}  
{% endcodeblock %}

## 序列化与反序列化的单例模式实现

静态内部类虽然保证了单例在多线程并发下的线程安全性，但是在遇到序列化对象时，默认的方式运行得到的结果就是多例的。
代码实现如下：
{% codeblock lang:java %}
import java.io.Serializable;  
  
public class MySingleton implements Serializable {  
       
    private static final long serialVersionUID = 1L;  
  
    //内部类  
    private static class MySingletonHandler{  
        private static MySingleton instance = new MySingleton();  
    }   
      
    private MySingleton(){}  
       
    public static MySingleton getInstance() {   
        return MySingletonHandler.instance;  
    }  
}  
{% endcodeblock %}

解决办法就是在反序列化的过程中使用readResolve()方法，单例实现的代码如下：

{% codeblock lang:java %}
import java.io.ObjectStreamException;  
import java.io.Serializable;  
  
public class MySingleton implements Serializable {  
       
    private static final long serialVersionUID = 1L;  
  
    //内部类  
    private static class MySingletonHandler{  
        private static MySingleton instance = new MySingleton();  
    }   
      
    private MySingleton(){}  
       
    public static MySingleton getInstance() {   
        return MySingletonHandler.instance;  
    }  
      
    //该方法在反序列化时会被调用，该方法不是接口定义的方法，有点儿约定俗成的感觉  
    protected Object readResolve() throws ObjectStreamException {  
        System.out.println("调用了readResolve方法！");  
        return MySingletonHandler.instance;   
    }  
}  
{% endcodeblock %}

## enum枚举实现单例模式

{% codeblock lang:java %}
public class ClassFactory{   
      
    private enum MyEnumSingleton{  
        singletonFactory;  
          
        private MySingleton instance;  
          
        private MyEnumSingleton(){//枚举类的构造方法在类加载是被实例化  
            instance = new MySingleton();  
        }  
   
        public MySingleton getInstance(){  
            return instance;  
        }  
    }   
   
    public static MySingleton getInstance(){  
        return MyEnumSingleton.singletonFactory.getInstance();  
    }  
}  
  
class MySingleton{//需要获实现单例的类，比如数据库连接Connection  
    public MySingleton(){}   
} 
{% endcodeblock %}

