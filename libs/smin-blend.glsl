// a is position 1
// b is position 2
// k is bias?

float sdf_smin(float a, float b, float k)
{
	float res = exp(-k * a) + exp(-k * b);
	return -log(max(0.0001, res)) / k;
}