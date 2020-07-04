class Arrays{

	static{
		System.loadLibrary("nativeArrays");
	}
	public native int[] reverse(int[] array);//method signature

	public static void main(String[] args) {
			
		Arrays arr = new Arrays();
		int[] array = new int[5];
		array[0]=0;array[1]=1;
		array[2]=2;array[3]=3;
		array[4]=4;
		array = arr.reverse(array);
		for (int i=0;i<array.length;++i) {
			System.out.print(array[i]+" ");
		}

	}



}