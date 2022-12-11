from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, filters
from rest_framework.authentication import TokenAuthentication
from profiles_api import serializers, models
from rest_framework import viewsets
from profiles_api import permissions
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.settings import api_settings


class HelloAPIView(APIView):
    """Test API View"""
    serializer_class = serializers.HelloSerializer
    
    def get(self, request, format=None):
        """Returns a list of APIView features"""
        
        an_apiview = [
            'Uses HTTP methods as function (get, post, patch, put, delete)',
            'Is similar to traditional Django View',
            'Gives you the most control over your app logic',
            'Has to be mapped manually to the URLs',
        ]
        
        return Response({'message': 'Hello!', 'an_apiview': an_apiview})
    
    def post(self, request):
        """Create a Hello Message with our Name"""
        serializer = self.serializer_class(data=request.data)
        
        if serializer.is_valid():
            name = serializer.validated_data.get('name')
            message = f'Hello {name}'
            return Response({'message': message})
        
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    def put(self, request, pk=None):
        """Handle updating an object - replacement"""    

        return Response({'method': 'put'})
    
    def patch(self, request, pk=None):
        """Handle partial updating of an object - update only selected fields"""    

        return Response({'method': 'patch'})
    
    def delete(self, request, pk=None):
        """Delete an object"""
        
        return Response({'method': 'delete'})
    
        
class HelloViewSet(viewsets.ViewSet):
    """Test APIViewset"""
    
    serializer_class = serializers.HelloSerializer

    def list(self, request):
        """Returns a list -> similar to GET"""
        
        a_viewset_list = [
            "Uses actions such as list, create, retrieve, update, partial_update",
            "Automatically maps to URLs using Routers",
            "Provides more functionality with less code"
        ]
        
        return Response({'message': "From ViewSet", "a_viewset": a_viewset_list})
    
    def create(self, request):
        """Create new hello message"""
        
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            name = serializer.validated_data.get('name')
            message = f'Hello {name}'
            return Response({'message': message})
        
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    def retrieve(self, request, pk=None):
        """Handles getting an object by its ID"""
        
        return Response({'http_method': 'GET'})
    
    def update(self, request, pk=None):
        """Handles updating an object by its ID"""
        
        return Response({'http_method': 'PUT'})
    
    def partial_update(self, request, pk=None):
        """Handles updating part of an object by its ID"""
        
        return Response({'http_method': 'PATCH'})
    
    def delete(self, request, pk=None):
        """Handles deleting an object by its ID"""
        
        return Response({'http_method': 'DELETE'})
    
    
class UserProfileViewset(viewsets.ModelViewSet):
    """Handle creating and updating profiles"""
    
    serializer_class = serializers.UserProfileSerializer
    queryset = models.UserProfile.objects.all()
    
    authentication_classes = (TokenAuthentication,)
    permission_classes = (permissions.UpdateOwnProfile,)
    
    filter_backends = (filters.SearchFilter,)
    search_fields = ('name', 'email',)
    

class UserLoginAPIView(ObtainAuthToken):
    """Handle creating user authentication tokens"""
    
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES
    