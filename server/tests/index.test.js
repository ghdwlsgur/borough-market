import request from 'supertest';
import app from '../index';

describe('express server response check', () => {
    it('should return 200 code', done => {
        request(app)
            .get('/status')
            .then(response => {
                expect(response.text).toBe('200');
                done();
            });
    });
});
