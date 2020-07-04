#include <jni.h>
#include "CallBack.h"
#include <stdlib.h>

JNIEXPORT void JNICALL Java_CallBack_callMe(JNIEnv *env, jobject obj, jint depth)
{
	jclass cls = (*env)->GetObjectClass(env,obj);
	jmethodID mid = (*env)->GetMethodID(env,cls,"callBack","(I)V");

	if(mid == 0){
		printf("ERROR---!\n");
		exit(1);
	}
	if(depth < 5)
	{
		printf("DEPTH = %d About to enter Java\n",depth);
		(*env)->CallVoidMethod(env,obj,mid,depth);
		printf("DEPTH = %d Back from Java\n",depth);
	}

}
