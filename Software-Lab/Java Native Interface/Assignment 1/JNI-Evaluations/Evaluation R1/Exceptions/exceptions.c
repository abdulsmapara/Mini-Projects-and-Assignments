#include "Exceptions.h"
#include <jni.h>

JNIEXPORT void JNICALL Java_Exceptions_CatchThrow(JNIEnv * env, jobject obj)
{
	jclass cls = (*env)->GetObjectClass(env,obj);
	jmethodID mid = (*env)->GetMethodID(env,cls,"call","()V");
	if(mid == 0){
		printf("ERROR----\n");return;
	}else{
		(*env)->CallVoidMethod(env,obj,mid);
		jthrowable exc = (*env)->ExceptionOccurred(env);
		if(exc){
			printf("Describing Exception---------\n");
			(*env)->ExceptionDescribe(env);
			(*env)->ExceptionClear(env);

			jclass newExcept_class = (*env)->FindClass(env,"java/lang/IllegalArgumentException");
			if(newExcept_class==0){
				return;
			}
			(*env)->ThrowNew(env,newExcept_class,"Thrown from C");


		}else{
			printf("Exception has not occured\n");
		}
	}
}
JNIEXPORT void JNICALL Java_Exceptions_another(JNIEnv * env, jobject obj)
{
	(*env)->ExceptionClear(env);
	printf("HERE\n");
	jclass newExcept_class = (*env)->FindClass(env,"java/lang/IllegalArgumentException");
	if(newExcept_class == 0){
		return;
	}
	(*env)->Throw(env,newExcept_class);
	jthrowable exc = (*env)->ExceptionOccurred(env);
	if(exc){
			printf("Describing Exception---------\n");
			(*env)->ExceptionDescribe(env);
			(*env)->ExceptionClear(env);
			printf("\n");
	}
}