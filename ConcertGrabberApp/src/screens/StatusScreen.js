import React, { useEffect, useState } from 'react';
import { View, Text } from 'react-native';
import { Card, Button } from 'shadcn-ui';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';

export default function StatusScreen() {
  const navigation = useNavigation();
  const [status, setStatus] = useState(null);

  const fetchStatus = async () => {
    try {
      const { data } = await axios.get('/api/status');
      setStatus(data);
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    fetchStatus();
    const timer = setInterval(fetchStatus, 5000);
    return () => clearInterval(timer);
  }, []);

  return (
    <View className="flex-1 bg-gray-100 p-4">
      <Text className="text-xl font-bold mb-4">Monitoring Status</Text>
      <Card className="p-4 rounded-xl shadow mb-4">
        {status ? (
          <>
            <Text className="mb-2">{status.message}</Text>
            <Text className="mb-1">Listening: {status.listening ? 'Yes' : 'No'}</Text>
            <Text className="mb-1">Grab Triggered: {status.triggered ? 'Yes' : 'No'}</Text>
          </>
        ) : (
          <Text>Loading...</Text>
        )}
      </Card>
      <Button onPress={() => navigation.navigate('Home')} className="rounded-xl">Back Home</Button>
    </View>
  );
}
