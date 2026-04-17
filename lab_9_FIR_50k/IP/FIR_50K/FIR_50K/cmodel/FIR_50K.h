
//------------------------------------------------------------------------------
// (c) Copyright 2023 Advanced Micro Devices. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------ 
//
// C Model configuration for the "FIR_50K" instance.
//
//------------------------------------------------------------------------------
//
// coefficients: -162,69,71,82,99,121,148,180,215,253,295,339,386,435,485,535,587,638,688,737,783,827,868,905,938,966,989,1006,1018,1024,1024,1018,1006,989,966,938,905,868,827,783,737,688,638,587,535,485,435,386,339,295,253,215,180,148,121,99,82,71,69,-162
// chanpats: 173
// name: FIR_50K
// data_coefficient_type: 0
// filter_type: 0
// rate_change: 0
// interp_rate: 1
// decim_rate: 1
// zero_pack_factor: 1
// coeff_padding: 2
// num_coeffs: 60
// coeff_sets: 1
// reloadable: 0
// is_halfband: 0
// quantization: 0
// coeff_width: 12
// coeff_fract_width: 0
// chan_seq: 0
// num_channels: 1
// num_paths: 1
// data_width: 9
// data_fract_width: 0
// output_rounding_mode: 1
// output_width: 9
// accum_width: 24
// output_fract_width: 0
// config_method: 0

const double FIR_50K_coefficients[60] = {-162,69,71,82,99,121,148,180,215,253,295,339,386,435,485,535,587,638,688,737,783,827,868,905,938,966,989,1006,1018,1024,1024,1018,1006,989,966,938,905,868,827,783,737,688,638,587,535,485,435,386,339,295,253,215,180,148,121,99,82,71,69,-162};

const xip_fir_v7_2_pattern FIR_50K_chanpats[1] = {P_BASIC};

static xip_fir_v7_2_config gen_FIR_50K_config() {
  xip_fir_v7_2_config config;
  config.name                = "FIR_50K";
  config.data_coefficient_type = XIP_FIR_REAL_TYPE;
  config.filter_type         = 0;
  config.rate_change         = XIP_FIR_INTEGER_RATE;
  config.interp_rate         = 1;
  config.decim_rate          = 1;
  config.zero_pack_factor    = 1;
  config.coeff               = &FIR_50K_coefficients[0];
  config.coeff_padding       = 2;
  config.num_coeffs          = 60;
  config.coeff_sets          = 1;
  config.reloadable          = 0;
  config.is_halfband         = 0;
  config.quantization        = XIP_FIR_INTEGER_COEFF;
  config.coeff_width         = 12;
  config.coeff_fract_width   = 0;
  config.chan_seq            = XIP_FIR_BASIC_CHAN_SEQ;
  config.num_channels        = 1;
  config.init_pattern        = FIR_50K_chanpats[0];
  config.num_paths           = 1;
  config.data_width          = 9;
  config.data_fract_width    = 0;
  config.output_rounding_mode= XIP_FIR_TRUNCATE_LSBS;
  config.output_width        = 9;
  config.accum_width         = 24;
  config.output_fract_width  = 0;
  config.config_method       = XIP_FIR_CONFIG_SINGLE;
  return config;
}

const xip_fir_v7_2_config FIR_50K_config = gen_FIR_50K_config();

