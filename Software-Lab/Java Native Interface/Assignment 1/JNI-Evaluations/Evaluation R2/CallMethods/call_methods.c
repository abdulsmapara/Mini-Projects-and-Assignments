#include <jni.h>
#include <stdio.h>
#include "CallMethods.h"

JNIEXPORT void JNICALL Java_CallMethods_callOne(JNIEnv *env, jobject obj1,jobject param_obj)
{
	jclass class = (*env)->GetObjectClass(env,param_obj);
	jmethodID methid = (*env)->GetMethodID(env,class,"retDouble","(ID)D");
	printf("%lf\n",(*env)->CallDoubleMethod(env,param_obj,methid,100,0.1));
}
JNIEXPORT void JNICALL Java_CallMethods_callTwo(JNIEnv *env, jobject obj1, jclass cls)
{
	jmethodID methid = (*env)->GetStaticMethodID(env,cls,"print","(Ljava/lang/String;)V");
	jstring js = (*env)->NewStringUTF(env,"Hi there");
	(*env)->CallStaticVoidMethod(env,cls,methid,js);
}
