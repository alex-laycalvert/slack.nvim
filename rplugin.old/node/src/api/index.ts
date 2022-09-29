import axios from 'axios'

export const testAuthentication = async () => {
    try {
        const response = await axios.post('https://slack.com/api/auth.test', {
            token: process.env.SLACK_API_TOKEN
        });
    } catch (e) {
        console.error(e);
        return null;
    }
}
