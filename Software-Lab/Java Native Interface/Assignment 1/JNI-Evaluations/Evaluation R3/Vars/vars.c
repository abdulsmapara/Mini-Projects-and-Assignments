#include <jni.h>
#include "Vars.h"


JNIEXPORT void JNICALL Java_Vars_demo(JNIEnv * env, jobject obj){

	jclass cls = (*env)->GetObjectClass(env,obj);
	jint x;
	jfieldID fid = (*env)->GetStaticFieldID(env, cls, "x", "I");
	if (fid == 0) {
    	return;
  	}
  	x = (*env)->GetStaticIntField(env, cls, fid);
  	printf("The int is %d\n",x);
	(*env)->SetStaticIntField(env, obj, fid, 200);
	x = (*env)->GetStaticIntField(env, cls, fid);
  	printf("The changed int is %d\n",x);
  	


	fid = (*env)->GetFieldID(env, cls, "y", "I");
	if (fid == 0) {
    	return;
  	}
  	jint y = (*env)->GetIntField(env, obj, fid);
  	printf("The int is %d\n",y);
	(*env)->SetIntField(env, obj, fid, 170);
	y = (*env)->GetIntField(env, obj, fid);
  	printf("The changed int is %d\n",y);


  	fid = (*env)->GetFieldID(env, cls, "str", "Ljava/lang/String;");
	if (fid == 0) {
    	return;
  	}
  jstring jstr = (*env)->GetObjectField(env, obj, fid);
    const char *str;
  str = (*env)->GetStringUTFChars(env, jstr, 0);
  printf("  s = \"%s\"\n", str);
  (*env)->ReleaseStringUTFChars(env, jstr, str);

  jstr = (*env)->NewStringUTF(env, "changed");
  (*env)->SetObjectField(env, obj, fid, jstr);
  str = (*env)->GetStringUTFChars(env, jstr, 0);
  printf("  s = \"%s\"\n", str);
  (*env)->ReleaseStringUTFChars(env, jstr, str); 
}