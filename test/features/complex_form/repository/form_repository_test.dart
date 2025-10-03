
// ignore_for_file: prefer_const_constructors
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:form_gemini_tutorial/core/network/api_client.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/real_form_model.dart';
import 'package:form_gemini_tutorial/features/complex_form/repository/form_repository.dart';

import 'form_repository_test.mocks.dart';

// 1. Anotación para generar el archivo de mocks
@GenerateMocks([ApiClient])
void main() {
  // 2. Declarar las variables que se usarán en los tests
  late FormRepository formRepository;
  late MockApiClient mockApiClient;

  // 3. setUp: se ejecuta antes de cada test individual
  setUp(() {
    mockApiClient = MockApiClient();
    // Inyectamos el mock en el repositorio
    formRepository = FormRepository(apiClient: mockApiClient);
  });

  // 4. Agrupar tests relacionados con una funcionalidad
  group('FormRepository Tests', () {
    
    group('submitForm', () {
      test('should return success result when submitting a form', () async {
        // Arrange: Preparar el escenario
        final testFormModel = RealFormModel(
          fullName: 'Test User',
          identification: '12345',
          providerType: 'IPS',
          isInReps: true,
          services: [],
          createdAt: DateTime.now(),
        );

        // Act: Ejecutar la acción que se está probando
        final result = await formRepository.submitForm(testFormModel);

        // Assert: Verificar que el resultado es el esperado
        expect(result.success, isTrue);
        expect(result.message, contains('enviada con éxito'));
        expect(result.submissionId, isNotNull);
      });
    });

    group('getAvailableServices', () {
      test('should return list of services from API on success', () async {
        // Arrange
        final apiResponse = {
          'services': ['Service A', 'Service B']
        };
        // Configuramos el mock para que devuelva una respuesta exitosa
        when(mockApiClient.get<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: apiResponse,
            statusCode: 200,
          ),
        );

        // Act
        final services = await formRepository.getAvailableServices();

        // Assert
        expect(services, equals(['Service A', 'Service B']));
        // Verificamos que el método 'get' del mock fue llamado
        verify(mockApiClient.get<Map<String, dynamic>>('/api/services/available')).called(1);
      });

      test('should return mock list of services when API call fails', () async {
        // Arrange
        // Configuramos el mock para que lance una excepción
        when(mockApiClient.get<Map<String, dynamic>>(any))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        // Act
        final services = await formRepository.getAvailableServices();

        // Assert
        // Verifica que devuelve la lista de fallback (mock)
        expect(services, isNotEmpty);
        expect(services, contains('Consulta Externa')); 
        verify(mockApiClient.get<Map<String, dynamic>>('/api/services/available')).called(1);
      });
    });

     group('getLocationsData', () {
      test('should return locations from API on success', () async {
        // Arrange
        final apiResponse = {
          'locations': {
            'Antioquia': ['Medellín', 'Bello'],
            'Cundinamarca': ['Bogotá']
          }
        };
        when(mockApiClient.get<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: apiResponse,
            statusCode: 200,
          ),
        );

        // Act
        final locations = await formRepository.getLocationsData();

        // Assert
        expect(locations.keys, containsAll(['Antioquia', 'Cundinamarca']));
        expect(locations['Antioquia'], equals(['Medellín', 'Bello']));
        verify(mockApiClient.get<Map<String, dynamic>>('/api/locations/colombia')).called(1);
      });

      test('should return mock locations when API call fails', () async {
        // Arrange
        when(mockApiClient.get<Map<String, dynamic>>(any))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        // Act
        final locations = await formRepository.getLocationsData();

        // Assert
        expect(locations.keys, contains('Valle del Cauca'));
        verify(mockApiClient.get<Map<String, dynamic>>('/api/locations/colombia')).called(1);
      });
    });
  });
}
