#include <jni.h>
#include "Strings.h"

JNIEXPORT void JNICALL Java_Strings_print
  (JNIEnv * env, jobject obj, jstring str)
{
	printf("%d\n",(*env)->GetStringUTFLength(env,str));
	const char* msg = (*env)->GetStringUTFChars(env,str,0);
	printf("%s\n",msg);
	(*env)->ReleaseStringUTFChars(env,str,msg);
}
JNIEXPORT jstring JNICALL Java_Strings_give(JNIEnv * env, jobject obj)
{
	return (*env)->NewStringUTF(env,"From C");
}