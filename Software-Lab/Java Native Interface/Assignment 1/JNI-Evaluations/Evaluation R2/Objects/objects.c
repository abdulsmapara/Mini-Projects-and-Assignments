#include "Objects.h"
#include <jni.h>

JNIEXPORT void JNICALL Java_Objects_create(JNIEnv *env, jclass class)
{
	jclass cls = (*env)->FindClass(env,"Objects");
	if(cls)
	{
		jobject jobj=(*env)->AllocObject(env,cls);
		jobject object;

		jmethodID constructor = (*env)->GetMethodID(env, cls, "<init>", "()V");
		if(constructor && jobj){
			object = (*env)->NewObject(env, cls, constructor, jobj);
		}
		else{
			printf("ERROR\n");
		}
		//(*env)->CallVoidMethod(env,obj,constructor)
	}
	else
	{
		printf("ERROR!!!!!!!!!!!\n");return;
	}
}