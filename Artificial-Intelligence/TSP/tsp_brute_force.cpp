// CPP program to implement traveling salesman 
// problem using naive approach. 
#include <bits/stdc++.h> 
using namespace std; 
int V;
int graph[1000][1000];
// implementation of traveling Salesman Problem 
int travllingSalesmanProblem(int s) 
{ 
	// store all vertex apart from source vertex 
	vector<int> vertex; 
	for (int i = 0; i < V; i++) 
		if (i != s) 
			vertex.push_back(i); 

	// store minimum weight Hamiltonian Cycle. 
	int min_path = INT_MAX; 
	do { 

		// store current Path weight(cost) 
		int current_pathweight = 0; 
		
		// compute current path weight 
		int k = s; 
		for (int i = 0; i < vertex.size(); i++) { 
			current_pathweight += graph[k][vertex[i]]; 
			k = vertex[i]; 
		} 
		current_pathweight += graph[k][s]; 

		// update minimum 
		min_path = min(min_path, current_pathweight); 
		
	} while (next_permutation(vertex.begin(), vertex.end())); 

	return min_path; 
} 
void tsp(vector<bool>& v, int currPos, 
         int n, int count, int cost, int& ans) 
{ 
      if (count == n && graph[currPos][0]) { 
        ans = min(ans, cost + graph[currPos][0]); 
        return; 
    } 

    for (int i = 0; i < n; i++) { 
        if (!v[i] && graph[currPos][i]) { 
              v[i] = true; 
            tsp(v, i, n, count + 1, cost + graph[currPos][i], ans); 
              v[i] = false; 
        } 
    } 
}
int main() 
{ 
	cin >> V;

	for (int i = 0; i < V; ++i)
	{
		graph[i][i] = 0;
		for(int j=i+1;j<V;j++){
			cin >> graph[i][j];
			graph[j][i] = graph[i][j];
		}

	}
	int n = V;
	vector<bool> v(n); 
    for (int i = 0; i < n; i++) 
        v[i] = false; 
  
    // Mark 0th node as visited 
    v[0] = true; 
    int ans = INT_MAX; 
  
    // Find the minimum weight Hamiltonian Cycle 
    tsp(v, 0, n, 1, 0, ans); 
  
    // ans is the minimum weight Hamiltonian Cycle 
    cout << ans; 
	 
	return 0; 
} 
