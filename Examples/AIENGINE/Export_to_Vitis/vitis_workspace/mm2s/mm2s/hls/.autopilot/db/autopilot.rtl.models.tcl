set SynModuleInfo {
  {SRCNAME mm2s MODELNAME mm2s RTLNAME mm2s IS_TOP 1
    SUBMODULES {
      {MODELNAME mm2s_gmem_m_axi RTLNAME mm2s_gmem_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME mm2s_control_s_axi RTLNAME mm2s_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME mm2s_regslice_both RTLNAME mm2s_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME mm2s_regslice_both_U}
    }
  }
}
