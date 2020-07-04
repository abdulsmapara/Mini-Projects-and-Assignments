#include <bits/stdc++.h>
using namespace std;

signed main(){

	srand(time(NULL)); 
	int n;
	cin >> n;
	cout << n << endl;
	int lower = 0;
	int upper = 50;
	for(int i=0;i<n;i++)
	{
		for(int j=i+1;j<n;j++){
			//cout << i+1 << ' ' << j+1 << ' ';
			int val = (rand() %(upper - lower + 1)) + lower;

			//if(rand()%100 == 97) val = 100000;

			// if(val == 0){
			// 	val = rand()%10;
			// }
			cout << val;

			cout << ' ';
		}
		cout << endl;
	}

	return 0;
}