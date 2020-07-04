#include <jni.h>
#include <stdio.h>
#include "Arrays.h"
JNIEXPORT jintArray JNICALL Java_Arrays_reverse(JNIEnv * env, jobject obj, jintArray array)
{

	jint *body = (*env)->GetIntArrayElements(env,array,0);
	jsize len = (*env)->GetArrayLength(env,array);

	for (int i = 0; i <= len/2; ++i)
	{
		int temp = body[i];
		body[i] = body[len-1-i];
		body[len-1-i] = temp;
	}
	(*env)->ReleaseIntArrayElements(env,array,body,0);
	return array;

}