#include <jni.h>
#include "SetSomeVars.h"

JNIEXPORT void JNICALL Java_SetSomeVars_modifyx
  (JNIEnv *env, jobject this, jobject obj, jint val){
  	jclass cls = (*env)->GetObjectClass(env,obj);
	jfieldID fid = (*env)->GetFieldID(env,cls,"x","I");
	(*env)->SetIntField(env,obj,fid,val);	//send object not class

}

JNIEXPORT void JNICALL Java_SetSomeVars_modifyy
  (JNIEnv *env, jobject this, jobject obj, jint val){
  	jclass cls = (*env)->GetObjectClass(env,obj);
  	jfieldID fid = (*env)->GetFieldID(env,cls,"y","I");
	(*env)->SetIntField(env,obj,fid,val);
  }