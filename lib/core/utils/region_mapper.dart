class RegionMapper {

  RegionMapper._();

  static const List<String> regions =[

    'Todas',
    'Sul',
    'Sudeste',
    'Centro-Oeste',
    'Nordeste',
    'Norte',
  ];

  static const Map<String, String> _stateToRegion = {
    // Sul
    'PR': 'Sul', 'RS': 'Sul', 'SC': 'Sul',
    'Paraná': 'Sul', 'Rio Grande do Sul': 'Sul', 'Santa Catarina': 'Sul',
    
    // Sudeste
    'SP': 'Sudeste', 'RJ': 'Sudeste', 'MG': 'Sudeste', 'ES': 'Sudeste',
    'São Paulo': 'Sudeste', 'Rio de Janeiro': 'Sudeste', 'Minas Gerais': 'Sudeste', 'Espírito Santo': 'Sudeste',
    
    // Centro-Oeste
    'MT': 'Centro-Oeste', 'MS': 'Centro-Oeste', 'GO': 'Centro-Oeste', 'DF': 'Centro-Oeste',
    'Mato Grosso': 'Centro-Oeste', 'Mato Grosso do Sul': 'Centro-Oeste', 'Goiás': 'Centro-Oeste', 'Distrito Federal': 'Centro-Oeste',
    
    // Nordeste
    'BA': 'Nordeste', 'PE': 'Nordeste', 'CE': 'Nordeste', 'RN': 'Nordeste', 
    'PB': 'Nordeste', 'MA': 'Nordeste', 'AL': 'Nordeste', 'SE': 'Nordeste', 'PI': 'Nordeste',
    'Bahia': 'Nordeste', 'Pernambuco': 'Nordeste', 'Ceará': 'Nordeste', 'Rio Grande do Norte': 'Nordeste', 
    'Paraíba': 'Nordeste', 'Maranhão': 'Nordeste', 'Alagoas': 'Nordeste', 'Sergipe': 'Nordeste', 'Piauí': 'Nordeste',
    
    // Norte
    'AM': 'Norte', 'PA': 'Norte', 'AC': 'Norte', 'RR': 'Norte', 'RO': 'Norte', 'AP': 'Norte', 'TO': 'Norte',
    'Amazonas': 'Norte', 'Pará': 'Norte', 'Acre': 'Norte', 'Roraima': 'Norte', 'Rondônia': 'Norte', 'Amapá': 'Norte', 'Tocantins': 'Norte',
  };

  static String getRegionFromState(String state) {
    return _stateToRegion[state] ?? 'Todas';
  }
}