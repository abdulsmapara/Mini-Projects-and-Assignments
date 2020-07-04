#include <jni.h>
#include "Array.h"

JNIEXPORT jobjectArray JNICALL Java_Array_mkArray(JNIEnv * env, jclass cls, jint sz)
{
	jclass c = (*env)->FindClass(env,"Domino");

	jobjectArray arr = (*env)->NewObjectArray(env,sz, c, NULL);
	jmethodID cid = (*env)->GetMethodID(env,c, "<init>", "(I)V");
	for (int k = 0; k < sz; k++)
	{
		jobject dom = (*env)->NewObject(env,c, cid, k + 100);
		(*env)->SetObjectArrayElement(env,arr, k, dom);
		(*env)->DeleteLocalRef(env,dom);
	}
	
	return arr;
}

JNIEXPORT jobject JNICALL Java_Array_ret
  (JNIEnv * env, jobject obj, jobjectArray arr, jint sz){
  		for(int i=0;i<sz;i++){
			jobject obj1 = (*env)->GetObjectArrayElement(env,arr,i);
			(*env)->SetObjectArrayElement(env,arr, i,obj1);
			(*env)->DeleteLocalRef(env,obj1);
		}
		return arr;
	
}