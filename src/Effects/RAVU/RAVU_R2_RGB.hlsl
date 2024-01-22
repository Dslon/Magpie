// This file is generated by the scripts available at https://github.com/hauuau/magpie-prescalers
// Please don't edit this file directly.
// Generated by: ravu.py --target rgb --weights-file weights\ravu_weights-r2.py --float-format float16dx --use-compute-shader --use-magpie --overwrite
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!MAGPIE EFFECT
//!VERSION 4

//!TEXTURE
Texture2D INPUT;

//!SAMPLER
//!FILTER POINT
SamplerState sam_INPUT;

//!TEXTURE
//!WIDTH  INPUT_WIDTH * 2
//!HEIGHT INPUT_HEIGHT * 2
Texture2D OUTPUT;

//!TEXTURE
//!SOURCE ravu_lut2_f16.dds
//!FORMAT R16G16B16A16_FLOAT
Texture2D ravu_lut2;

//!SAMPLER
//!FILTER LINEAR
SamplerState sam_ravu_lut2;

//!TEXTURE
//!FORMAT R16G16B16A16_FLOAT
//!WIDTH  INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
Texture2D ravu_int11;

//!SAMPLER
//!FILTER POINT
SamplerState sam_ravu_int11;

//!COMMON
#include "prescalers.hlsli"

#define LAST_PASS 2

//!PASS 1
//!DESC RAVU (step1, rgb, r2, compute)
//!IN INPUT, ravu_lut2
//!OUT ravu_int11
//!BLOCK_SIZE 32, 8
//!NUM_THREADS 32, 8
static const vec3 color_primary = vec3(0.2126, 0.7152, 0.0722);
shared vec3 inp0[385];
shared float inp_luma0[385];

#define CURRENT_PASS 1

#define GET_SAMPLE(x) x
#define imageStore(out_image, pos, val) imageStoreOverride(pos, val.xyz)
void imageStoreOverride(uint2 pos, vec3 value) { ravu_int11[pos] = vec4(value, 0.0); }

#define INPUT_tex(pos) GET_SAMPLE(vec4(texture(INPUT, pos)))
static const float2 INPUT_size = float2(GetInputSize());
static const float2 INPUT_pt = float2(GetInputPt());

#define ravu_lut2_tex(pos) (vec4(texture(ravu_lut2, pos)))

#define HOOKED_tex(pos) INPUT_tex(pos)
#define HOOKED_size INPUT_size
#define HOOKED_pt INPUT_pt

void Pass1(uint2 blockStart, uint3 threadId) {
	ivec2 group_base = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
	int local_pos = int(gl_LocalInvocationID.x) * 11 + int(gl_LocalInvocationID.y);
	{
		for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
			uint x = (uint)id / 11, y = (uint)id % 11;
			inp0[id] =
				HOOKED_tex(HOOKED_pt * vec2(float(group_base.x + x) + (-0.5), float(group_base.y + y) + (-0.5))).xyz;
			inp_luma0[id] = dot(inp0[id], color_primary);
		}
	}
	barrier();
#if CURRENT_PASS == LAST_PASS
	uint2 destPos = blockStart + threadId.xy * 2;
	uint2 outputSize = GetOutputSize();
	if (destPos.x >= outputSize.x || destPos.y >= outputSize.y) {
		return;
	}
#endif
	{
		float luma0 = inp_luma0[local_pos + 0];
		float luma4 = inp_luma0[local_pos + 11];
		float luma5 = inp_luma0[local_pos + 12];
		float luma6 = inp_luma0[local_pos + 13];
		float luma7 = inp_luma0[local_pos + 14];
		float luma1 = inp_luma0[local_pos + 1];
		float luma8 = inp_luma0[local_pos + 22];
		float luma9 = inp_luma0[local_pos + 23];
		float luma10 = inp_luma0[local_pos + 24];
		float luma11 = inp_luma0[local_pos + 25];
		float luma2 = inp_luma0[local_pos + 2];
		float luma12 = inp_luma0[local_pos + 33];
		float luma13 = inp_luma0[local_pos + 34];
		float luma14 = inp_luma0[local_pos + 35];
		float luma15 = inp_luma0[local_pos + 36];
		float luma3 = inp_luma0[local_pos + 3];
		vec3 abd = vec3(0.0, 0.0, 0.0);
		float gx, gy;
		gx = (luma4 - luma0);
		gy = (luma1 - luma0);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma5 - luma1);
		gy = (luma2 - luma0) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma6 - luma2);
		gy = (luma3 - luma1) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma7 - luma3);
		gy = (luma3 - luma2);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma8 - luma0) / 2.0;
		gy = (luma5 - luma4);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma9 - luma1) / 2.0;
		gy = (luma6 - luma4) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma10 - luma2) / 2.0;
		gy = (luma7 - luma5) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma11 - luma3) / 2.0;
		gy = (luma7 - luma6);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma4) / 2.0;
		gy = (luma9 - luma8);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma13 - luma5) / 2.0;
		gy = (luma10 - luma8) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma14 - luma6) / 2.0;
		gy = (luma11 - luma9) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma15 - luma7) / 2.0;
		gy = (luma11 - luma10);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma8);
		gy = (luma13 - luma12);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma13 - luma9);
		gy = (luma14 - luma12) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma14 - luma10);
		gy = (luma15 - luma13) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma15 - luma11);
		gy = (luma15 - luma14);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		float a = abd.x, b = abd.y, d = abd.z;
		float T = a + d, D = a * d - b * b;
		float delta = sqrt(max(T * T / 4.0 - D, 0.0));
		float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
		float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
		float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
		float lambda = sqrtL1;
		float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
		float angle = floor(theta * 24.0 / 3.141592653589793);
		float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
		float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
		float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
		vec3 res = vec3(0.0, 0.0, 0.0);
		vec4 w;
		w = texture(ravu_lut2, vec2(0.25, coord_y));
		res += (inp0[local_pos + 0] + inp0[local_pos + 36]) * w[0];
		res += (inp0[local_pos + 1] + inp0[local_pos + 35]) * w[1];
		res += (inp0[local_pos + 2] + inp0[local_pos + 34]) * w[2];
		res += (inp0[local_pos + 3] + inp0[local_pos + 33]) * w[3];
		w = texture(ravu_lut2, vec2(0.75, coord_y));
		res += (inp0[local_pos + 11] + inp0[local_pos + 25]) * w[0];
		res += (inp0[local_pos + 12] + inp0[local_pos + 24]) * w[1];
		res += (inp0[local_pos + 13] + inp0[local_pos + 23]) * w[2];
		res += (inp0[local_pos + 14] + inp0[local_pos + 22]) * w[3];
		res = clamp(res, 0.0, 1.0);
		imageStore(out_image, ivec2(gl_GlobalInvocationID), vec4(res, 1.0));
	}
}
//!PASS 2
//!DESC RAVU (step2, rgb, r2, compute)
//!IN INPUT, ravu_lut2, ravu_int11
//!OUT OUTPUT
//!BLOCK_SIZE 64, 16
//!NUM_THREADS 32, 8
static const vec3 color_primary = vec3(0.2126, 0.7152, 0.0722);
shared vec3 inp0[385];
shared float inp_luma0[385];
shared vec3 inp1[385];
shared float inp_luma1[385];

#define CURRENT_PASS 2

#define GET_SAMPLE(x) x
#define imageStore(out_image, pos, val) imageStoreOverride(pos, val)
void imageStoreOverride(uint2 pos, float4 value) { OUTPUT[pos] = value; }

#define INPUT_tex(pos) GET_SAMPLE(vec4(texture(INPUT, pos)))
static const float2 INPUT_size = float2(GetInputSize());
static const float2 INPUT_pt = float2(GetInputPt());

#define ravu_lut2_tex(pos) (vec4(texture(ravu_lut2, pos)))

#define ravu_int11_tex(pos) (vec3(texture(ravu_int11, pos).xyz))
static const float2 ravu_int11_size = float2(GetInputSize().x, GetInputSize().y);
static const float2 ravu_int11_pt = float2(1.0 / (ravu_int11_size.x), 1.0 / (ravu_int11_size.y));

#define HOOKED_tex(pos) INPUT_tex(pos)
#define HOOKED_size INPUT_size
#define HOOKED_pt INPUT_pt

void Pass2(uint2 blockStart, uint3 threadId) {
	ivec2 group_base = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
	int local_pos = int(gl_LocalInvocationID.x) * 11 + int(gl_LocalInvocationID.y);
	{
		for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
			uint x = (uint)id / 11, y = (uint)id % 11;
			inp0[id] =
				ravu_int11_tex(ravu_int11_pt * vec2(float(group_base.x + x) + (-1.5), float(group_base.y + y) + (-1.5)))
					.xyz;
			inp_luma0[id] = dot(inp0[id], color_primary);
		}
	}
	{
		for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
			uint x = (uint)id / 11, y = (uint)id % 11;
			inp1[id] =
				HOOKED_tex(HOOKED_pt * vec2(float(group_base.x + x) + (-0.5), float(group_base.y + y) + (-0.5))).xyz;
			inp_luma1[id] = dot(inp1[id], color_primary);
		}
	}
	barrier();
#if CURRENT_PASS == LAST_PASS
	uint2 destPos = blockStart + threadId.xy * 2;
	uint2 outputSize = GetOutputSize();
	if (destPos.x >= outputSize.x || destPos.y >= outputSize.y) {
		return;
	}
#endif
	{
		float luma8 = inp_luma0[local_pos + 12];
		float luma5 = inp_luma0[local_pos + 13];
		float luma2 = inp_luma0[local_pos + 14];
		float luma13 = inp_luma0[local_pos + 23];
		float luma10 = inp_luma0[local_pos + 24];
		float luma7 = inp_luma0[local_pos + 25];
		float luma0 = inp_luma0[local_pos + 2];
		float luma15 = inp_luma0[local_pos + 35];
		float luma12 = inp_luma1[local_pos + 11];
		float luma9 = inp_luma1[local_pos + 12];
		float luma6 = inp_luma1[local_pos + 13];
		float luma3 = inp_luma1[local_pos + 14];
		float luma4 = inp_luma1[local_pos + 1];
		float luma14 = inp_luma1[local_pos + 23];
		float luma11 = inp_luma1[local_pos + 24];
		float luma1 = inp_luma1[local_pos + 2];
		vec3 abd = vec3(0.0, 0.0, 0.0);
		float gx, gy;
		gx = (luma4 - luma0);
		gy = (luma1 - luma0);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma5 - luma1);
		gy = (luma2 - luma0) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma6 - luma2);
		gy = (luma3 - luma1) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma7 - luma3);
		gy = (luma3 - luma2);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma8 - luma0) / 2.0;
		gy = (luma5 - luma4);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma9 - luma1) / 2.0;
		gy = (luma6 - luma4) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma10 - luma2) / 2.0;
		gy = (luma7 - luma5) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma11 - luma3) / 2.0;
		gy = (luma7 - luma6);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma4) / 2.0;
		gy = (luma9 - luma8);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma13 - luma5) / 2.0;
		gy = (luma10 - luma8) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma14 - luma6) / 2.0;
		gy = (luma11 - luma9) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma15 - luma7) / 2.0;
		gy = (luma11 - luma10);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma8);
		gy = (luma13 - luma12);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma13 - luma9);
		gy = (luma14 - luma12) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma14 - luma10);
		gy = (luma15 - luma13) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma15 - luma11);
		gy = (luma15 - luma14);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		float a = abd.x, b = abd.y, d = abd.z;
		float T = a + d, D = a * d - b * b;
		float delta = sqrt(max(T * T / 4.0 - D, 0.0));
		float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
		float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
		float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
		float lambda = sqrtL1;
		float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
		float angle = floor(theta * 24.0 / 3.141592653589793);
		float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
		float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
		float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
		vec3 res = vec3(0.0, 0.0, 0.0);
		vec4 w;
		w = texture(ravu_lut2, vec2(0.25, coord_y));
		res += (inp0[local_pos + 2] + inp0[local_pos + 35]) * w[0];
		res += (inp1[local_pos + 2] + inp1[local_pos + 23]) * w[1];
		res += (inp0[local_pos + 14] + inp0[local_pos + 23]) * w[2];
		res += (inp1[local_pos + 14] + inp1[local_pos + 11]) * w[3];
		w = texture(ravu_lut2, vec2(0.75, coord_y));
		res += (inp1[local_pos + 1] + inp1[local_pos + 24]) * w[0];
		res += (inp0[local_pos + 13] + inp0[local_pos + 24]) * w[1];
		res += (inp1[local_pos + 13] + inp1[local_pos + 12]) * w[2];
		res += (inp0[local_pos + 25] + inp0[local_pos + 12]) * w[3];
		res = clamp(res, 0.0, 1.0);
		imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 1), vec4(res, 1.0));
	}
	{
		float luma4 = inp_luma0[local_pos + 12];
		float luma1 = inp_luma0[local_pos + 13];
		float luma12 = inp_luma0[local_pos + 22];
		float luma9 = inp_luma0[local_pos + 23];
		float luma6 = inp_luma0[local_pos + 24];
		float luma3 = inp_luma0[local_pos + 25];
		float luma14 = inp_luma0[local_pos + 34];
		float luma11 = inp_luma0[local_pos + 35];
		float luma8 = inp_luma1[local_pos + 11];
		float luma5 = inp_luma1[local_pos + 12];
		float luma2 = inp_luma1[local_pos + 13];
		float luma0 = inp_luma1[local_pos + 1];
		float luma13 = inp_luma1[local_pos + 22];
		float luma10 = inp_luma1[local_pos + 23];
		float luma7 = inp_luma1[local_pos + 24];
		float luma15 = inp_luma1[local_pos + 34];
		vec3 abd = vec3(0.0, 0.0, 0.0);
		float gx, gy;
		gx = (luma4 - luma0);
		gy = (luma1 - luma0);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma5 - luma1);
		gy = (luma2 - luma0) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma6 - luma2);
		gy = (luma3 - luma1) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma7 - luma3);
		gy = (luma3 - luma2);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma8 - luma0) / 2.0;
		gy = (luma5 - luma4);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma9 - luma1) / 2.0;
		gy = (luma6 - luma4) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma10 - luma2) / 2.0;
		gy = (luma7 - luma5) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma11 - luma3) / 2.0;
		gy = (luma7 - luma6);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma4) / 2.0;
		gy = (luma9 - luma8);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma13 - luma5) / 2.0;
		gy = (luma10 - luma8) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma14 - luma6) / 2.0;
		gy = (luma11 - luma9) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
		gx = (luma15 - luma7) / 2.0;
		gy = (luma11 - luma10);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma12 - luma8);
		gy = (luma13 - luma12);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		gx = (luma13 - luma9);
		gy = (luma14 - luma12) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma14 - luma10);
		gy = (luma15 - luma13) / 2.0;
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
		gx = (luma15 - luma11);
		gy = (luma15 - luma14);
		abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
		float a = abd.x, b = abd.y, d = abd.z;
		float T = a + d, D = a * d - b * b;
		float delta = sqrt(max(T * T / 4.0 - D, 0.0));
		float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
		float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
		float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
		float lambda = sqrtL1;
		float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
		float angle = floor(theta * 24.0 / 3.141592653589793);
		float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
		float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
		float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
		vec3 res = vec3(0.0, 0.0, 0.0);
		vec4 w;
		w = texture(ravu_lut2, vec2(0.25, coord_y));
		res += (inp1[local_pos + 1] + inp1[local_pos + 34]) * w[0];
		res += (inp0[local_pos + 13] + inp0[local_pos + 34]) * w[1];
		res += (inp1[local_pos + 13] + inp1[local_pos + 22]) * w[2];
		res += (inp0[local_pos + 25] + inp0[local_pos + 22]) * w[3];
		w = texture(ravu_lut2, vec2(0.75, coord_y));
		res += (inp0[local_pos + 12] + inp0[local_pos + 35]) * w[0];
		res += (inp1[local_pos + 12] + inp1[local_pos + 23]) * w[1];
		res += (inp0[local_pos + 24] + inp0[local_pos + 23]) * w[2];
		res += (inp1[local_pos + 24] + inp1[local_pos + 11]) * w[3];
		res = clamp(res, 0.0, 1.0);
		imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 0), vec4(res, 1.0));
	}
	vec3 res;
	res = inp0[local_pos + 24];
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 1), vec4(res, 1.0));
	res = inp1[local_pos + 12];
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 0), vec4(res, 1.0));
}
